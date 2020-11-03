module Stanza
  class TokenizerPos

    DESC        = 'Tokenizer / POS by Stanza'
    VERSION     = '1.0'

    BASE_URL    = "#{ENV['STANZA_SERVER']}/?lang=%{lang}&input=%{input}"

    POS         = {
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
      'SCONJ' => 'P'
    }

    def run input, params
      kaf      = Opener::KAF::Document.from_xml input
      url      = URI.encode(BASE_URL % { lang: kaf.language, input: kaf.raw })

      response = Faraday.get(url)
      tokens   = JSON.parse response.body

      w_index = 0
      tokens.each_with_index do |sentence, s_index|
        sentence.each_with_index do |word|
          w_index += 1
          misc   = word['misc']
          offset = misc.match(/start_char=(\d+)|/)[1].to_i
          length = misc.match(/end_char=(\d+)/)[1].to_i - offset

          u_pos  = word['upos']
          print word['lemma']
          raise "Didn't find a map for #{u_pos}" if POS[u_pos].nil?
          type   = ['N','R','G','V','A','O'].include?(POS[u_pos]) ? 'open' : 'close'

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
            pos:        POS[u_pos],
            type:       type,
          }

          kaf.add_word_form params
          kaf.add_term params
        end
      end

      kaf.add_linguistic_processor DESC, "#{VERSION}", 'text', timestamp: true

      kaf.to_xml
    rescue JSON::ParserError => e
      raise Opener::Core::UnsupportedLanguageError, kaf.language
    end

  end
end
