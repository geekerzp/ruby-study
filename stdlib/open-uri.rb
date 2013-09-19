# ====================
# | Ruby发送HTTP请求 |
# ====================

# GET
# ~~~

    require "open-uri"  
      
    #如果有GET请求参数直接写在URI地址中  
    uri = 'http://uri'  
    html_response = nil  
    open(uri) do |http|  
      html_response = http.read  
    end  
    puts html_response  
    
# POST
# ~~~~

    params = {}  
    params["name"] = 'Tom'  
    uri = URI.parse("http://uri")  
    res = Net::HTTP.post_form(uri, params)   
      
    #返回的cookie  
    puts res.header['set-cookie']  
    #返回的html body  
    puts res.body  

# https-仅验证服务器
# ~~~~~~~~~~~~~~~~~~

    require 'net/https'
    require 'uri'
 
    uri = URI.parse('https://liuwm-pc:8081/2.html')
 
    http = Net::HTTP.new(uri.host, uri.port)
 
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要
 
    http.start {
      http.request_get(uri.path) {|res|
        print res.body
      }
    }
    
# https-双向验证
# ~~~~~~~~~~~~~~

    require 'net/https'
    require 'uri'
 
    uri = URI.parse('https://liuwm-pc:8081/2.html')
 
    http = Net::HTTP.new(uri.host, uri.port)
 
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.cert =OpenSSL::X509::Certificate.ne(File.read("D:/111/client.crt"))
    http.key =OpenSSL::PKey::RSA.new((File.read("D:/111/client.key")), "123456")# key and password
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要
 
    http.start {
      http.request_get(uri.path) {|res|
        print res.body
      }
    }

# https-双向验证
# ~~~~~~~~~~~~~~

    require 'net/http'
    require 'net/https'
    require 'openssl'
    require 'uri'

    ContentURI = URI.parse("https://palladium.wejn.cz/sslcerttest/")
    @cert_raw = File.read('client.pem')
    @cert_key_raw = @cert_raw
    TestDataPath = '.'

    req = Net::HTTP::Get.new(ContentURI.path)
    https = Net::HTTP.new(ContentURI.host, ContentURI.port)
    https.use_ssl = true
    https.cert = OpenSSL::X509::Certificate.new(@cert_raw)
    https.key = OpenSSL::PKey::RSA.new(@cert_key_raw)
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.ca_file = File.join(TestDataPath, 'cacert.pem')
    resp = https.start { |cx| cx.request(req) }
    p resp
    p resp.body
