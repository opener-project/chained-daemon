module Opener
  module Stanza
    class Processor

      DESC            = 'Tokenizer / POS by Stanza'
      VERSION         = '1.0'

      BASE_URL        = ENV['STANZA_SERVER']
      LANGUAGES_CACHE = Opener::ChainedDaemon::LanguagesCache.new

      RTL_LANGUAGES   = %w[
        ar ara arc ae ave egy he heb nqo pal phn sam
        syc syr fa per fas ku kur ur urd
      ]

      POS             = {
        'DET'   => 'D',
        'ADJ'   => 'G',
        'NOUN'  => 'N',
        'VERB'  => 'V',
        'AUX'   => 'V',
        'ADV'   => 'A',
        'CCONJ' => 'J',
        'PUNCT' => '.',
        'ADP'   => 'P',
        'PRON'  => 'Q',
        'PROPN' => 'R',
        'PART'  => 'P',
        'NUM'   => 'O',
        'X'     => 'O',
        'SYM'   => 'O',
        'SCONJ' => 'P',
        'INTJ'  => 'O',
      }

      POS_OPEN        = %w[N R G V A O]

      def run input, params
        raise 'missing Stanza server' if ENV['STANZA_SERVER'].blank?

        kaf      = KAF::Document.from_xml input
        lang     = LANGUAGES_CACHE.get[kaf.language]
        env      = params.cache_keys.environment
        unless lang&.environments&.include? env or (env == 'staging' and lang&.environments&.include? 'production')
          raise Core::UnsupportedLanguageError.new kaf.language
        end

        input     = kaf.raw
        input     = input.gsub(/\,[^\ ]/, ', ')
        response  = Faraday.post BASE_URL, {lang: kaf.language, input: input}.to_query
        raise Core::UnsupportedLanguageError, kaf.language if response.status == 406
        raise response.body if response.status >= 400
        sentences = JSON.parse response.body
        sentences.each{ |s| s.map!{ |t| Hashie::Mash.new t } }

        w_index = 0

        miscs = {}
        sentences.each.with_index do |s, i|
          miscs[i] = {}
          s.each do |word|
            word.id.is_a?(Array) && word.id.each{ |id| miscs[i][id] = word.misc }
          end
        end

        sentences.map{ |s| s.reverse! } if RTL_LANGUAGES.include? kaf.language
        sentences.each.with_index do |s, s_index|
          s.each do |word|
            w_index += 1
            # save misc for later usase in a MWT case
            next if word.id.is_a? Array

            misc = word.misc || miscs[s_index][word.id]

            Rollbar.scoped({ input: input, params: params, sentences: sentences, word: word }) do
              raise 'Missing misc'
            end if misc.nil?

            offset = misc.match(/start_char=(\d+)|/)[1].to_i
            length = misc.match(/end_char=(\d+)/)[1].to_i - offset

            u_pos  = word.upos
            pos    = POS[u_pos]
            raise "Didn't find a map for #{u_pos}" if pos.nil?
            type   = if POS_OPEN.include? pos then 'open' else 'close' end

            params = Hashie::Mash.new(
              wid:        w_index,
              sid:        s_index + 1,
              tid:        w_index,
              para:       1,
              offset:     offset,
              length:     length,
              text:       word.text,
              lemma:      word.lemma,
              morphofeat: u_pos,
              pos:        pos,
              type:       type,
              head:       word.head,
            )

            kaf.add_word_form params
            kaf.add_term params
          end
        end

        kaf.add_linguistic_processor DESC, "#{VERSION}", 'text', timestamp: true

        kaf.to_xml
      end

    end
  end
end
