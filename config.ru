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
      this_page = pages.first
      this_page['entries'] = this_page['entries'][0..(this_page['page_size']-1)] if this_page['entries'] and this_page['page_size']
      return this_page
    else
      this_page = {}
      slugs.each do |slug|
        if this_page['page'] and slug == 'archive'
          return archive.first
        else
          (this_page['entries'] || pages).each do |page|
            this_page = page if page['slug'] == slug
          end
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
      'page' => true,
      'page_size' => 2,
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
          'entry' => true
        },
        {
          'id' => 4,
          'title' => 'This drink',
          'slug' => 'this-drink',
          'url' => '/menu/this-drink/',
          'body' => 'This and that.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-11-01',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true
        },
        {
          'id' => 5,
          'title' => 'That drink',
          'slug' => 'that-drink',
          'url' => '/menu/that-drink/',
          'body' => 'That and this.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-11-01',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true,
          'last' => true
        }
      ]
    }]
  end
  
  def archive
    [{
      'page_id' => 1,
      'page_name' => 'Menu',
      'title' => 'Archive',
      'url' => '/menu/archive/',
      'archive' => true,
      'entries' => [ # all entries
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
          'entry' => true
        },
        {
          'id' => 4,
          'title' => 'This drink',
          'slug' => 'this-drink',
          'url' => '/menu/this-drink/',
          'body' => 'This and that.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-11-01',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true
        },
        {
          'id' => 5,
          'title' => 'That drink',
          'slug' => 'that-drink',
          'url' => '/menu/that-drink/',
          'body' => 'That and this.',
          'excerpt' => '',
          'description' => '',
          'published_at' => '2012-11-01',
          'month' => 'December',
          'day' => '15',
          'year' => '2012',
          'entry' => true,
          'last' => true
        }
      ],
      'years' => [
        {
          'year' => 2012,
          'months' => [ #all months that have this year
            {
              'month' => 'December',
              'entries' => [] #all entries this month
            },
            {
              'month' => 'November',
              'entries' => [] #all entries this month
            }
          ],
          'entries' => [] #all entries this year
        }
      ]
    }]
  end
  
end

run Siteleaf.new