Puppet::Type.newtype(:cinder_api_uwsgi_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from /etc/cinder/cnder-api-uwsgi.ini'
    newvalues(/\S+\/\S+/)
  end

  newparam(:ensure_absent_val) do
    desc 'A value that is specified as the value property will behave as if ensure => absent was specified'
    defaultto('<SERVICE DEFAULT>')
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end
    newvalues(/^[\S ]*$/)
  end

  autorequire(:anchor) do
    ['cinder::install::end']
  end

end
