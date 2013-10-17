require 'rubygems'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

#require File.join('/Users/deimel/Dropbox/bash', 'lib', 'jira_ticket')

class JiraTicket

  include Capybara::DSL

  def initialize(ticket_number)
    @id = ticket_number
    @url =  "https://tickets.miceportal.de"
  end

  def new_session
    require 'capybara/poltergeist'
    Capybara.register_driver :proxied_poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, :phantomjs_options => [ '--ignore-ssl-errors=yes'], :phantomjs_logger  => open('/dev/null'))
    end
    Capybara.current_driver = :proxied_poltergeist

    # Start up a new thread
    Capybara::Session.new(:poltergeist)

  end

  def session
    @session ||= new_session
  end

  def html
    session.html
  end

  def login
    session
    visit("#{@url}/login.jsp")
    fill_in "Benutzername", :with => ENV['JIRA_USER']
    fill_in "Passwort", :with => ENV['JIRA_PW']
    find('#login-form-submit').click

#   raise "can't login with user: #{ENV['JIRA_USER']}" #if current_path.to_s =~ /login/

end

def title
  visit(url)
    #puts find('#summary-val').native.all_text
    find('#summary-val').native.all_text
  end

  def to_qa
    visit(url)
    find('#action_id_711').click
  end

  def to_todo
    visit(url)
    find('#action_id_301').click
  end

  def to_start
    visit(url)
    find('#action_id_4').click
  end

  def add_comment(comment)
    visit(url)
    find('#comment-issue').click
    fill_in "Kommentar", :with => comment
    find('#issue-comment-add-submit').click
  end

  def url
    "#{@url}/browse/#{ticket}"
  end

  def ticket
    "MP-#{@id}"
  end

  def weekly_plan
    selected_issue =" &selectedIssue=#{ticket}" if @id
    "#{@url}/secure/RapidBoard.jspa?quickFilter=1&rapidView=1#{selected_issue}"
  end

  def self.add_comment(ticket_number,comment)
    jira = JiraTicket.new(ticket_number)
    jira.login
    jira.add_comment comment
  end

  def self.title(ticket_number)
    jira = JiraTicket.new(ticket_number)
    jira.login
    jira.title.chomp.downcase
  end

  def self.weekly_plan(ticket_number=nil)
    jira = JiraTicket.new(ticket_number)
    jira.weekly_plan
  end

  def self.to_qa(ticket_number)
    jira = JiraTicket.new(ticket_number)
    jira.login
    jira.to_qa
  end

  def self.to_start(ticket_number)
    jira = JiraTicket.new(ticket_number)
    jira.login
    jira.to_start
  end

  def self.to_todo(ticket_number)
    jira = JiraTicket.new(ticket_number)
    jira.login
    jira.to_todo
  end

  def self.show(ticket_number)
   jira = JiraTicket.new(ticket_number)
   system "open #{jira.url}"
 end

end
