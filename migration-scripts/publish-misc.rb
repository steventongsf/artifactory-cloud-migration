#!/usr/bin/env ruby

Dir["maven/*.jar"].each {|entry|
  name = File.basename(entry)
  if name =~ /^Web/ || name =~ /^JavaWeb/
    group = "com.microstrategy"
  elsif name =~ /^com\.ibm\.mq/ || name =~ /^dhbcore/
    group =  "webspheremq"
  elsif name =~ /xercesImpl/ || name =~ /xml-api/
    group =  "org.apache.xerces"
  elsif name =~ /netezza/
    group =  "netezza"
  elsif name =~ /db2/
    group = "com.ibm.db2"
  elsif name =~ /jbpm/
    group = "org.jbpm"
  elsif name =~ /obe/
    group = "org.obe"
  elsif name =~ /^JSON/
    group = "ibm"
  elsif name =~ /datastreams/
    group = "com.ibm.swg.datastreams"
  end

  tmp = name.gsub(".jar","")
  artifact = tmp.split("-")[0]
  version = tmp.split("-")[1]
  cmd  = "mvn deploy:deploy-file"
  cmd << " -DgroupId=#{group}"
  cmd << " -DartifactId=#{artifact}"
  cmd << " -Dversion=#{version}"
  cmd << " -Dfile=#{entry}"
  cmd << " -Dpackaging=jar"
  cmd << " -s settings.stong.xml"
  #cmd << " -Durl=http://localhost:8081/artifactory/libs-release"
  cmd << " -Durl=https://artifactory.acoustic.co:443/artifactory/dt-maven-releases-virtual"
  cmd << " -DrepositoryId=dt-acoustic-releases"
  puts "*" * 25
  puts cmd
  puts group
  puts artifact
  puts version
  puts entry
  "Failed executing "+cmd if system(cmd)
}


puts "Done"
