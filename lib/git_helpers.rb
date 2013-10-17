require File.join(File.dirname(__FILE__), "jira_ticket")
require File.join(File.dirname(__FILE__), "common_helper")

module GitHelpers
  include CommonHelper

  def branch
    current_branch
  end

  def exce(command)
    puts command
    puts system command
  end

  def app
    File.basename(File.expand_path('.'))
  end

  def last_commit
    most_recent_commit
  end

  # Returns the SHA1 hash of the most recent git commit.
  def most_recent_commit
    `git log | head -n 1 | cut -d " " -f 2`
  end

  def current_branch
    `git symbolic-ref HEAD`.strip.sub("refs/heads/", "")
  end

  def current_user
    `git config github.user`.strip
  end

  def current_token
    `git config github.token`.strip
  end

  def branch_exits?(branch_name)
    system "git show-ref --verify --quiet refs/heads/#{branch_name} "
    $? == 0
  end

  def current_ticket
    current_branch[/^\d+/].to_s.strip.to_i
  end

  def ticket_url
    JiraTicket.new(current_ticket).url
  end

  def weekly_plan_url
    JiraTicket.new(current_ticket).weekly_plan
  end

  def github_app_name
    remote_url = `git remote show -n origin`.split("\n").grep(/Push/).first.split.grep(/github/)[0]
    remote_url.split(':')[1].sub(/\.git$/, '')
  end

  def github_api_url
    remote_url = `git remote show -n origin`.split("\n").grep(/Push/).first.split.grep(/github/)[0]
    user_and_repo = remote_url.split(':')[1].sub(/\.git$/, '')

    # URI.parse("https://github.com/api/v2/json/pulls/#{user_and_repo}")
    "https://api.github.com/repos/#{user_and_repo}/pulls"
  end

  def staging_url
    app_name = app.downcase == 'katalysator' ? 'www' :  app.downcase
    "https://#{app_name}.beta.miceportal.de"
  end

  def merge(target_branch)
    puts "****merge '#{branch}' into #{target_branch}"
    exce "git checkout #{target_branch}"
    exce "git pull origin #{target_branch}"
    @last_commit = last_commit
    exce "git merge #{branch}"
    exce "git push origin #{target_branch}"
    @commit = last_commit
  end
end
