require 'openssl'

class Certificate < ActiveRecord::Base
#before_create :create_x509_name
#before_save :create_root_certificate

#def create_x509_name
def initialize(args = nil)
  @x509_subject = OpenSSL::X509::Name.new
  super
end

def create_certificate
  self.subject = @x509_subject.to_s
  self.issuer = @issuer.subject
  key = OpenSSL::PKey::RSA.generate(1024)
  pub = key.public_key
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  self.version = 2
  #replace with a setting value (what happens when you delete something?)
  serial = Certificate.count
  self.serial = serial
  cert.serial = serial
  cert.subject = @x509_subject
  cert.issuer = OpenSSL::X509::Name.parse(@issuer.subject)
  cert.public_key = pub
  cert.not_before = self.not_before
  cert.not_after = self.not_after

  issuer_key = OpenSSL::PKey::RSA.new(File.read("public/certificates/key-"+@issuer.serial.to_s+".pem"))
  cert.sign issuer_key, OpenSSL::Digest::SHA1.new
  File.open("public/certificates/key-"+serial.to_s+".pem", "w") {|f| f.write key.send("to_pem") }
  File.open("public/certificates/cert-"+serial.to_s+".pem", "w") {|f| f.write cert.send("to_pem") }
  self.save
end

def create_root_certificate
  self.ca = true
  self.subject = @x509_subject.to_s
  self.issuer = @x509_subject.to_s
  key = OpenSSL::PKey::RSA.generate(1024)
  pub = key.public_key
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  self.version = 2
  #replace with a setting value (what happens when you delete something?)
  serial = Certificate.count
  self.serial = serial
  cert.serial = serial
  cert.subject = @x509_subject
  cert.issuer = @x509_subject
  cert.public_key = pub
  cert.not_before = self.not_before
  cert.not_after = self.not_after
  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = cert
  ef.issuer_certificate = cert
  cert.extensions = [
    ef.create_extension("basicConstraints","CA:TRUE", true),
    ef.create_extension("subjectKeyIdentifier", "hash"),
    ef.create_extension("keyUsage", "cRLSign,keyCertSign", true),
  ]
  cert.add_extension ef.create_extension("authorityKeyIdentifier",
                                       "keyid:always,issuer:always")

  cert.sign key, OpenSSL::Digest::SHA1.new
  File.open("public/certificates/key-"+serial.to_s+".pem", "w") {|f| f.write key.send("to_pem") }
  File.open("public/certificates/cert-"+serial.to_s+".pem", "w") {|f| f.write cert.send("to_pem") }
  self.save
end

def country
end

def country=(country)
  @x509_subject.add_entry('C', country)
  logger.info 'country ='+country
end

def state
end

def state=(state)
  @x509_subject.add_entry('ST', state)
  logger.info @x509_subject.to_s
end

def city
end

def city=(city)
  @x509_subject.add_entry('L', city)
end

def organization_name
end

def organization_name=(orgname)
  @x509_subject.add_entry('O', orgname)
end

def organizational_unit_name
end

def organizational_unit_name=(oguname)
  @x509_subject.add_entry('OU', oguname)
end


def CN
  subject = OpenSSL::X509::Name.parse(self.subject).to_a
  subject_h = Hash[*subject.collect { |v|
      [v[0], v[1]]
  }.flatten]
  subject_h['CN']
end

def issuer_CN
  issuer = OpenSSL::X509::Name.parse(self.issuer).to_a
  issuer_h = Hash[*issuer.collect { |v|
      [v[0], v[1]]
  }.flatten]
  issuer_h['CN']
end

def common_name
end

def common_name=(common_name)
  @x509_subject.add_entry('CN', common_name)
end

def email_address
end

def email_address=(email)
  @x509_subject.add_entry('emailAddress', email)
end

def issuer_id
end

def issuer_id=(issuer)
  @issuer = Certificate.find(issuer)
  logger.info "issuer: "+@issuer.CN
end

end
