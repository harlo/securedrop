# ensure hosts file references mon server by ip
# TODO: replace hardcoded ip for mon-staging host
describe file('/etc/hosts') do
  its(:content) { should match /^127\.0\.1\.1 app-staging app-staging$/ }
  # TODO: the "securedrop-monitor-server-alias" is an artifact of
  # using the vagrant-hostmanager plugin. it may no longer be necessary
  its(:content) { should match /^10\.0\.1\.3  mon-staging securedrop-monitor-server-alias$/ }
end

# ensure custom ossec-agent package is installed
describe package('securedrop-ossec-agent') do
  it { should be_installed }
end

# ensure client keyfile for ossec-agent is present
describe file('/var/ossec/etc/client.keys') do
  it { should be_file }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'ossec' }
  # this regex checks for a hex string of 64 chars, not a specific value
  its(:content) { should match /^1024 app-staging 10\.0\.1\.2 [0-9a-f]{64}$/ }
end
