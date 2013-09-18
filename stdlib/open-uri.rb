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
