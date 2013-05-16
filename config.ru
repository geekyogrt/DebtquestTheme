require 'mustache'

class Siteleaf
  def call(env)    
    domain = 'barlawrence'
    template = 'template.html'
    
    path = env['PATH_INFO']
    local_path = path[1..-1]
    if !File.directory?(local_path) and File.exists?(local_path)
      Rack::File.new(Dir.pwd).call(env)
    else    
      data = get_page(local_path)
      data['site'] = site
      stache = Mustache.new
      stache.template_file = template
      output = stache.render(data)
      [200, {'Content-Type' => 'text/html'}, [output]]
    end
  end
  
  def get_page(path)
    slugs = path.split('/')
    if slugs.count == 0
      return pages.first
    else
      this_page = {}
      slugs.each do |slug|
        (this_page['entries'] || pages).each do |page|
          this_page = page if page['slug'] == slug
        end
      end
      return this_page
    end
  end
  
  # fake api data
  def site
    {
      'id' => 1,
      'title' => 'Bar Lawrence',
      'slug' => 'barlawrence',
      'url' => 'http://barlawrence.com',
      'timezone' => 'GMT'
    }
  end
  
  def pages
    [{
      'id' => 1,
      'title' => 'Menu',
      'slug' => 'menu',
      'url' => '/',
      'body' => '',
      'excerpt' => '',
      'description' => '',
      'date' => '2012-11-01',
      'month' => 'November',
      'day' => '1',
      'year' => '2012',
      'entries' => [
        {
          'id' => 2,
          'title' => 'Champagne Cocktail',
          'slug' => 'champagne-cocktail',
          'url' => '/menu/champagne-cocktail/',
          'body' => 'Champagne, St. Germain, bitters.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-12-15',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true,
          'first' => true
        },
        {
          'id' => 3,
          'title' => 'French 75',
          'slug' => 'french-75',
          'url' => '/menu/french-75/',
          'body' => 'Gin, simple syrup, lemon juice, champagne.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-12-15',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true,
          'last' => true
        }
      ]
    }]
  end
end

run Siteleaf.new