require 'sinatra'
set :protection, :except => :frame_options

read_cookie = "(function(){
    var cookies;

    function readCookie(name,c,C,i){
        if(cookies){ return cookies[name]; }

        c = document.cookie.split('; ');
        cookies = {};

        for(i=c.length-1; i>=0; i--){
           C = c[i].split('=');
           cookies[C[0]] = C[1];
        }

        return cookies[name];
    }

    window.readCookie = readCookie; // or expose it however you want
})();"

get '/testwrite' do
  response.set_cookie "thirdparty", "set"
  redirect "/test-read"
  "<html>
<head>
<script type='text/javascript'>
" + read_cookie +"
function testCookie(){
var p = document.getElementById('cookiestatus');
p.innerText= window.readCookie('thirdparty') ? 'cookie set' : 'cookie not set';
}
</script>
</head>
<body onload='testCookie()'>third party site loaded
<p id='cookiestatus'>

</p>
</body>
</html>"
end

get '/set-cookie' do
  response.set_cookie "thirdparty", "set"
  "cookie set"
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
  redirect "https://diqhvogfdw.localtunnel.me/read-test"
end
