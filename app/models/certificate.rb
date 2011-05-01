require 'openssl'

class Certificate < ActiveRecord::Base
#before_create :create_x509_name
before_save :create_certificate

#def create_x509_name
def initialize(args = nil)
  @x509_subject = OpenSSL::X509::Name.new
  super
end

def create_certificate
  self.subject = @x509_subject.to_s

  key = OpenSSL::PKey::RSA.generate(1024)
  pub = key.public_key
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  #replace with a setting value (what happens when you delete something?)
  serial = Certificate.maximum(:id) + 1
  cert.serial = serial
  cert.subject = @x509_subject
  cert.issuer = @x509_subject
  cert.public_key = pub
  cert.not_before = self.not_before
  cert.not_after = self.not_after
  File.open("public/certificates/cert-"+serial.to_s+".pem", "w") {|f| f.write key.send("to_pem") }
  File.open("public/certificates/key-"+serial.to_s+".pem", "w") {|f| f.write cert.send("to_pem") }
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

end
