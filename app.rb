require 'sinatra'
set :protection, :except => :frame_options
configure do
  mime_type :javascript, 'text/javascript'
end

set_cookie = "function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = 'expires=' + d.toGMTString();
    document.cookie = cname+'='+cvalue+'; '+expires;
}
"
get '/testwrite' do
  response.set_cookie "thirdparty", "set"
  "<html>
<head>
<script type='text/javascript'>
window.location.replace('/test-read');
</script>
</head>
<body onload=''>third party site loaded
<p id='cookiestatus'>

</p>
</body>
</html>"
end

get '/set-cookie' do
  response.set_cookie "thirdparty", "set"
  "cookie set"
end

get '/javascript' do
  content_type :javascript
  set_cookie + "
setCookie('thirdparty','setviajs',1);"
end

get '/test-read' do
  value = request.cookies["thirdparty"]
  value ? "cookie set value:#{value}" : "cookie not set"
end

get '/clear-cookie' do
  response.delete_cookie "thirdparty"
  "cookie cleared"
end

get '/test-redirect' do
  response.set_cookie "thirdparty", "set"
  redirect "http://ec2-54-205-25-185.compute-1.amazonaws.com:3000/read-test"
end
