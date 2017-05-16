#!/usr/bin/env ruby
require 'watir'
require_relative 'options'

# Get config
config = Options.parse

# Editable vars
USERNAME = config[:username]
PASSWORD = config[:password]
FULL_NAME = config[:name_folder] # Used to open folder of the same name
EVIDENCE_FOLDER_NAME = config[:upload_folder] # Used to put evidence in. CREATE ON THE SITE BEFORE HAND

# Script Vars
evidence_paths = config[:files]
if evidence_paths.empty?
  puts 'ERROR: No paths given'
  exit
end

puts 'Will upload: ' + evidence_paths.map { |path| path.split('/').last }.join(', ')

# Begin script
browser = Watir::Browser.new :chrome

# Login
browser.goto 'https://justit.itslearning.com/'
browser.text_field(id: 'ctl00_ContentPlaceHolder1_Username_input').set USERNAME
browser.text_field(id: 'ctl00_ContentPlaceHolder1_Password_input').set PASSWORD
browser.send_keys :enter

# Navigate to directory
# Change to Sainsbury's course
browser.span(class: 'l-menu-text', text: 'Courses').click
browser.span(class: 'ccl-iconlink course-menu-item dropdown-menu-item', text: 'Sainsbury\'s').click
# Navigate to 'your name' directory
container = browser.li(id: 'content')
name_folder = container.ul.li.ul.lis.last.a
name_folder.click
# Open evidence portfolio
internal_iframe = browser.section(class: 'l-main-content').iframe.body
main_panel = internal_iframe.div(id: 'ctl00_MainHolder')
main_panel.a(class: 'GridTitle', title: 'Evidence Portfolio').click
# Open enclosing folder
folder = main_panel.a(class: 'GridTitle', title: EVIDENCE_FOLDER_NAME)
unless folder.exists?
  puts "ERROR: Folder '#{EVIDENCE_FOLDER_NAME}' doesn't exist. Have you created it on the site?"
  exit
end
folder.click

for path in evidence_paths do
  file_name = path.split('/').last
  puts "Uploading `#{file_name}`..."

  # Click Add
  main_panel.a(id: 'ctl00_ContentPlaceHolder_ProcessFolderGrid_GTB_ToolbarAddElementLink').click
  main_panel.a(text: 'File or link').click

  # Get new panel for this page
  upload_panel = internal_iframe.div(id: 'ctl00_BodyWrapper')

  # Upload file
  buttons_panel = upload_panel.div(id: 'ctl00_MainHolder').iframe(id: 'ctl00_ContentPlaceHolder_ExtensionIframe').body.div(class: 'ccl-formcontainer')
  browse_button = buttons_panel.a(class: 'ccl-fileuploader-button ccl-button ccl-button-color-green')
  begin
    browse_button.input.to_subtype.set(path)
    # Rename
    file_title = upload_panel.h1(class: 'ccl-pageheader')
    file_title.a(title: 'Click to edit title').click
    title_text_field = file_title.text_field
    title_text_field.set(file_name)
    title_text_field.send_keys :enter
    # Save
    buttons_panel.button(value: 'Save').click
  rescue Watir::Exception::ObjectDisabledException, Selenium::WebDriver::Error::UnknownError
     # If unable to save, carry on
     puts "`#{file_name}` could not be saved! It may have taken more than 30 seconds to upload or was unable to be uploaded in the first place"
  end

  # Return to folder
  browser.section(id: 'l-quick-orientation').a(text: EVIDENCE_FOLDER_NAME).click
end

# So you can view the files momentarily
puts 'Done! Closing in 5'
sleep(5)
browser.quit
