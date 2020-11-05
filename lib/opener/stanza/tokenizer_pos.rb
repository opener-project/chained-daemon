module Opener
  module Stanza
    class TokenizerPos

      DESC     = 'Tokenizer / POS by Stanza'
      VERSION  = '1.0'

      BASE_URL = ENV['STANZA_SERVER']

      POS      = {
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

      POS_OPEN = %w[N R G V A O]

      def run input, params
        raise 'missing Stanza server' if ENV['STANZA_SERVER'].blank?

        kaf      = KAF::Document.from_xml input
        response = Faraday.post BASE_URL, {lang: kaf.language, input: kaf.raw}.to_query
        raise Core::UnsupportedLanguageError, kaf.language if response.status == 406
        raise response.body if response.status >= 400
        tokens   = JSON.parse response.body

        w_index = 0
        tokens.each_with_index do |sentence, s_index|
          sentence.each_with_index do |word|
            w_index += 1
            misc   = word['misc']
            offset = misc.match(/start_char=(\d+)|/)[1].to_i
            length = misc.match(/end_char=(\d+)/)[1].to_i - offset

            u_pos  = word['upos']
            pos    = POS[u_pos]
            raise "Didn't find a map for #{u_pos}" if pos.nil?
            type   = if POS_OPEN.include? pos then 'open' else 'close' end

            params = {
              wid:        w_index,
              sid:        s_index + 1,
              tid:        w_index,
              para:       1,
              offset:     offset,
              length:     length,
              text:       word['text'],
              lemma:      word['lemma'],
              morphofeat: u_pos,
              pos:        pos,
              type:       type,
            }

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
