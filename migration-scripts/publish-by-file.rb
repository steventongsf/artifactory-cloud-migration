#!/usr/bin/env ruby


def process_bower()
  folder = "bower"
  exts = ["zip","tar","tar.gz"]
  files = []

  artifacts = []

  exts.each {|ext|
    cmd = "find #{folder} -name '*.#{ext}'"
    array = `#{cmd}`.split("\n")
    array.each {|v| files << v }
  }

  files.each {|f| 
    artifact = {}
    artifact[:groupId] = folder
    artifact[:artifactId] = File.basename(f.rpartition("-")[0])
    artifact[:ext] = File.extname(f).gsub(".","")
    artifact[:ext] = "tar.gz" if artifact[:ext] == "gz"
    artifact[:version] = f.rpartition("-")[2].split("."+artifact[:ext])[0]
    artifact[:file] = f
    artifacts << artifact
  }
  return artifacts
end

def process_x1()

end

REPOURL = " -Durl=https://artifactory.acoustic.co:443/artifactory/dt-maven-releases-virtual"

p 

def publish_cmd(artifact) 
  a = artifact
  cmd  = "mvn deploy:deploy-file"
  cmd << " -DgroupId=#{a[:groupId]}"
  cmd << " -DartifactId=#{a[:artifactId]}"
  cmd << " -Dversion=#{a[:version]}"
  cmd << " -Dfile=#{a[:file]}"
  cmd << " -Dpackaging=#{a[:ext]}"
  cmd << " -s settings.stong.xml"
  cmd << " -Durl=#{REPOURL}"
  cmd << " -DrepositoryId=dt-acoustic-releases"
end
def publish_bower()
  artifacts = process_bower()
  artifacts = []
  artifacts.each {|a|
    p cmd = publish_cmd(a)
    p `#{cmd}`
    raise "Failed publishing artifact #{a[:artifactId]}" if $? != 0
  }
  return artifacts
end
def process_x1()
  folder = "x1"
  groupId = "com.ibm.emm.x1"
  exts = ["tar.gz"]
  files  = []
  artifacts = []
  exts.each {|ext|
    cmd = "find #{folder} -name '*.#{ext}'"
    array = `#{cmd}`.split("\n")
    array.each {|v| files << v }
  }
  files.each {|f| 
    artifact = {}
    name = File.basename(f.rpartition("-")[0])
    artifact[:groupId] = groupId
    artifact[:artifactId] = name.rpartition("-")[0]
    artifact[:ext] = File.extname(f).gsub(".","")
    artifact[:ext] = "tar.gz" if artifact[:ext] == "gz"
    artifact[:classifier] = f.rpartition("-")[2].split("."+artifact[:ext])[0]
    artifact[:version] = name.rpartition("-")[2]
    artifact[:file] = f
    artifacts << artifact
  }
  return artifacts
end
def publish_x1()
  artifacts = process_x1()
  artifacts.each {|a|
    p cmd = publish_cmd(a)
    #p `#{cmd}`
    raise "Failed publishing artifact #{a[:artifactId]}" if $? != 0
  }
  return artifacts
end

publish_bower()  if ARGV[0] =~ /bower/
publish_x1() if ARGV[0] =~ /x1/








