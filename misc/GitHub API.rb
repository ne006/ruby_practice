require 'open-uri'
require 'json'

def query_gh(
  api_path = "commits",
  user = "ne006",
  repo = "ruby_practice"
)

  uri_s = "https://api.github.com/repos/#{user}/#{repo}/#{api_path}"

  data = (Thread.new do
    JSON.parse (URI.parse uri_s).read
  end).value

  data

end


head_sha = query_gh("git/refs/heads/master")["object"]["sha"]

tree_sha = query_gh("commits/#{head_sha}")["commit"]["tree"]["sha"]

subtree_sha = (query_gh("git/trees/#{tree_sha}")["tree"].select do |e|
  e["path"] == "design_patterns"
end).first["sha"]

subtree = query_gh("git/trees/#{subtree_sha}")["tree"].map do |f|
  f["path"]
end

puts subtree