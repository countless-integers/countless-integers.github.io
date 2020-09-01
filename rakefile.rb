require 'date'

namespace :post do

  desc 'create a new post'
  task :create do
    title = ENV['title']
    if !title
        abort("No title given. Pass a title for the post as 'title' env param")
    end
    title = title.strip
    date = "#{Date.today}"
    slug = "#{date}-#{title.downcase.gsub(/[^\w]+/, '-')}"

    new_post_path = File.join(
      File.dirname(__FILE__),
      '_posts',
      slug + '.md'
    )

    File.open(new_post_path, "w") do |file|
      file << <<~TEXT
      ---
      layout: post
      title: #{title}
      date: #{date}
      published: false
      categories:
      ---

      TEXT
    end

    system ("#{ENV['EDITOR']} #{new_post_path}")
  end
end
