require 'spec_helper'

describe 'cinder::cron::db_purge' do

  let :facts do
    { :osfamily => 'RedHat' }
  end

  let :params do
    { :minute      => 1,
      :hour        => 0,
      :monthday    => '*',
      :month       => '*',
      :weekday     => '*',
      :user        => 'cinder',
      :age         => '30',
      :destination => '/var/log/cinder/cinder-rowsflush.log' }
  end

  it 'configures a cron' do
    is_expected.to contain_cron('cinder-manage db purge').with(
      :command     => "cinder-manage db purge #{params[:age]} >>#{params[:destination]} 2>&1",
      :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
      :user        => params[:user],
      :minute      => params[:minute],
      :hour        => params[:hour],
      :monthday    => params[:monthday],
      :month       => params[:month],
      :weekday     => params[:weekday],
      :require     => 'Anchor[cinder::install::end]'
    )
  end
end
