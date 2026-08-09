module Jekyll
  class WordColorizerFilter < Liquid::Filter
    def colorize_words(text)
      # Get the word colors from the data file
      colors = @context.registers[:site].data['word_colors']
      return text unless colors  # Return unmodified if no colors defined
      
      colors = colors['word_colors'] if colors.is_a?(Hash) && colors['word_colors']
      return text unless colors  # Return unmodified if no word_colors key
      
      result = text.dup
      # Sort by length (longest first) to avoid partial replacements
      colors.keys.sort_by { |k| -k.length }.each do |word|
        color = colors[word]
        # Use word boundary regex to match whole words only
        pattern = /\b#{Regexp.escape(word)}\b/i
        result.gsub!(pattern) do |match|
          "<span style=\"color: #{color};\">#{match}</span>"
        end
      end
      result
    end
  end
end

Liquid::Template.register_filter(Jekyll::WordColorizerFilter)
