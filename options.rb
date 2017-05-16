# A script that will pretend to resize a number of images
 require 'optparse'
 require 'yaml'

 class Options
   def self.parse
     options = {}

     optparse = OptionParser.new do |opts|
       # Set a banner, displayed at the top
       # of the help screen.
       opts.banner = "Usage: jifu [-f UPLOAD_FOLDER, -n NAME_FOLDER, -u USERNAME, -p PASSWORD] file1 file2 ..."

       config = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))

       options[:upload_folder] = config['upload_folder']
       options[:name_folder] = config['name_folder']
       options[:username] = config['username']
       options[:password] = config['password']

       opts.on( '-f', '--folder UPLOAD_FOLDER', 'Specifies folder where all files are uploaded - not required if specified in config.yml' ) do |upload_folder|
         options[:upload_folder] = upload_folder
       end

       opts.on( '-n', '--full_name NAME_FOLDER', 'Specifies full name folder on site - not required if specified in config.yml' ) do |name_folder|
         options[:name_folder] = name_folder
       end

       opts.on( '-u', '--username USERNAME', 'Specifies login username - not required if specified in config.yml' ) do |username|
         options[:username] = username
       end

       opts.on( '-u', '--password PASSWORD', 'Specifies login password - not required if specified in config.yml' ) do |password|
         options[:password] = password
       end

       # This displays the help screen, all programs are
       # assumed to have this option.
       opts.on( '-h', '--help', 'Display this screen' ) do
         puts opts
         puts "\nNote: specifying `.` will use all files in the current folder"
         exit
       end
     end

     if options.has_value? nil
       puts 'WARNING MISSING CONFIG. Please include a folder, full name, username and password in either config.yml or as a command line arguement?'
       exit
     end

     files = optparse.parse!.uniq
     # Include whole folder
     if files.include? '.'
       files = files + Dir.entries(".")
       files = files - ['.', '..']
     end

     # Remove files starting with `.` or `~`, replace them with their full paths and get rid of dups
     options[:files] = files.select { |file| !(file.start_with?('.') || file.start_with?('~'))}.map { |file| File.join(Dir.getwd, file) }.uniq

     return options
   end
 end

#puts Options.parse
