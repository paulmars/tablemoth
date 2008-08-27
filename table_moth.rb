module TableMoth

  def tablurize(collection, options = {:row_length => 4}, &block)
    row_length = options[:row_length]
    class_name = collection.first.class.to_s.downcase
    options[:first_row] = true
    content_tag = "<table class=\"#{class_name.pluralize} gridlayout\">"
    (1+collection.size/row_length).times do |row|
      row_collection = collection[row*row_length,row_length]
      content_tag += capture(row_collection, options, &block)
      options[:first_row] = false
    end
    content_tag += "</table>"
    block_is_within_action_view?(block) ? concat(content_tag, block.binding) : content_tag
  end

  def rowize(row_collection, options = {:row_length => 4}, &block)
    content_tag = "<tr>"
    class_name = row_collection.first.class.to_s.downcase

    width = (100.0/options[:row_length]).to_i

    row_collection.each do |item|
      content = capture(item, &block)
      content_tag += "<td width=\"#{width}%\" class=\"#{class_name}\" #{"style=\"#{options[:style]}\"" if options[:style]} valign=\"middle\">#{content}</td>"
    end

    # attempt at filling out the row, so the item isn't centered
    if options[:first_row]
      (options[:row_length] - row_collection.size).times do |row|
        content_tag += "<td width=\"#{width}%\" class=\"#{class_name}\" #{"style=\"#{options[:style]}\"" if options[:style]} valign=\"middle\"></td>"
      end
    end
    content_tag += "</tr>"

    block_is_within_action_view?(block) ? concat(content_tag, block.binding) : content_tag
  end

end