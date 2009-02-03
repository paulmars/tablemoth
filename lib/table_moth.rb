module TableMoth

  def tablurize(collection, options = {}, &block)
    return nil if collection.empty?

    row_length = (options[:row_length] ||= 4)
    css_class = (options[:css_class] ||= collection.first.class.to_s.downcase)
    options[:first_row] = true
    row_number = (1+collection.size/row_length)

    content = content_tag :table, {:class => "#{css_class.pluralize} gridlayout"} do
      rows = []
      row_number.times do |row|
        row_collection = collection[row*row_length,row_length]
        rows << capture(row_collection, options, &block)
        options[:first_row] = false
      end
      rows.join
    end
    block_called_from_erb?(block) ? concat(content) : content
  end

  def rowize(row_collection, options, &block)
    css_class = options[:css_class]
    width = (100.0/options[:row_length]).to_i
    html_options = {:width => "#{width}%", :class => css_class, :valign => "middle"}
    html_options[:style] = options[:style] if options[:style]

    content = content_tag :tr do
      full = row_collection.collect do |item|
        content_tag :td, html_options do
          capture(item, &block)
        end
      end

      # if first row is partially empty
      if options[:first_row]
        (options[:row_length] - row_collection.size).times do |row|
          full << (content_tag :td, nil, html_options)
        end
      end

      full.join
    end
    block_called_from_erb?(block) ? concat(content) : content
  end


  # string based concatination alternative

  # def tablurize(collection, options = {}, &block)
  #   return nil if collection.empty?
  #
  #   row_length = (options[:row_length] ||= 4)
  #   css_class = (options[:css_class] ||= collection.first.class.to_s.downcase)
  #   options[:first_row] = true
  #   row_number = (1+collection.size/row_length)
  #
  #   content = "<table class=\"#{css_class.pluralize} gridlayout\">"
  #
  #   rows = []
  #   row_number.times do |row|
  #     row_collection = collection[row*row_length,row_length]
  #     rows << capture(row_collection, options, &block)
  #     options[:first_row] = false
  #   end
  #
  #   content << "#{rows.join}</table>"
  #
  #   block_called_from_erb?(block) ? concat(content) : content
  # end
  #
  # def rowize(row_collection, options, &block)
  #   width = (100.0/options[:row_length]).to_i
  #
  #   td_options = <<-TDOPTIONS
  #     width=\"#{width}%\" class=\"#{options[:css_class]}\" valign=\"middle\"
  #   TDOPTIONS
  #
  #   td_options += "style=\"#{options[:style]}\"" if options[:style]
  #
  #   content = "<tr>"
  #
  #   tds = []
  #
  #   row_collection.each do |item|
  #     tds << <<-TD
  #       <td #{td_options}>
  #         #{capture(item, &block)}
  #       </td>
  #     TD
  #   end
  #
  #   # if first row is partially empty
  #   if options[:first_row]
  #     (options[:row_length] - row_collection.size).times do |row|
  #       tds << <<-TD
  #         <td #{td_options}></td>
  #       TD
  #     end
  #   end
  #
  #   content << "#{tds.join}</tr>"
  #
  #   block_called_from_erb?(block) ? concat(content) : content
  # end

end