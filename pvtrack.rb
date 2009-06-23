#require 'rubygems'
require 'activeresource'

# pvtrack --project=1985 --token=XXX
TOKEN = 'ade3888ee1018b123a3c074a3bbae3ab'
PROJECT = '1895'

OPTION_REGEX = /^--?(\w+)=(.+)$/

# parse command line arguments (token, project_id)
options = ARGV.map { |arg| arg.scan(OPTION_REGEX) }.flatten
OPTIONS = Hash[*options]

OPTIONS['token'] = TOKEN
OPTIONS['project_id'] = PROJECT

raise ArgumentError.new("You need to provide your API token from PivotalTracker") if OPTIONS['token'].blank?
raise ArgumentError.new("You need to provide a project_id") if OPTIONS['project_id'].blank?


class Story < ActiveResource::Base
  self.site = "http://www.pivotaltracker.com/services/v2/projects/#{OPTIONS['project_id']}"
  headers['X-TrackerToken'] = OPTIONS['token']
  
  # TODO: maybe not needed, make sure first
  def to_xml
    super(:dasherize => false)
  end
end

# Create a story

STORY = Story.new(:name => "Another test Story from Ruby command line client", :story_type => 'feature', :requested_by => "Dennis Theisen", :description => "This is for testing out a command line client in Ruby using ActiveResource", :project_id => OPTIONS['project_id'])

# Find stories
#Story.find(STORY_ID, :params => {:project_id => PROJECT_ID})
#Story.find(:all, :params => {:project_id => PROJECT_ID})
#Story.find(:all, :params => {:filter => "label:'needs feedback' type:bug", :project_id => PROJECT_ID})

# Update a story
#story = Story.find(STORY_ID, :params => {:project_id => PROJECT_ID})
#story.name = "More speed Scotty"
#story.save 
