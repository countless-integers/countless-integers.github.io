desc 'create a new post'
task :newPost do
  require 'date'
  title = ENV['TITLE']
  if !title
      abort("No title given. Pass a title for the post as 'TITLE' env param")
  end
  slug = "#{Date.today}-#{title.downcase.gsub(/[^\w]+/, '-')}"
  date = "#{Date.today}"

  file = File.join(
    File.dirname(__FILE__),
    '_posts',
    slug + '.markdown'
  )

  File.open(file, "w") do |f|
    f << <<-EOS.gsub(/^    /, '')
    ---
    layout: post
    title: #{title}
    date: #{date}
    published: false
    categories:
    ---

    EOS
  end

  system ("#{ENV['EDITOR']} #{file}")
end
