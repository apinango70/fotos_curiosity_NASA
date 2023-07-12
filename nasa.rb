#Crear el método request que reciba una url y retorne el hash con los resultados
def request(url)
  require "uri" 
  require "net/http" 
  require "json" 

  url = URI(url) 
  https = Net::HTTP.new(url.host, url.port) 
  https.use_ssl = true

  #Ejecuto el GET a la url y btengo en formato Json los datos recibidos del GET
  request = Net::HTTP::Get.new(url) 
  response = https.request(request)  
  results = JSON.parse(response.read_body) 
end

# Crear un método llamado buid_web_page que reciba el hash de respuesta con todos los datos y construya una página web. Se evaluará la página creada y tiene que tener este formato:
# <html>
# <head>
# </head>
# <body>
# <ul>
# <li><img src='.../398380645PRCLF0030000CC AM04010L1.PNG'></li>
# <li><img src='.../398381687EDR_F0030000CCAM05010M_.JPG'></li>
# </ul>
# </body>
# </html>

def build_web_page(data)
  photos = data["photos"][1..20].map { |x| x["img_src"] } 
  output = "<html>\n"
  output += "<head>\n"
  output += "<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css' integrity='sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO' crossorigin='anonymous'>\n"
  output += "<title>Fotos API Nasa</title>\n"
  output += "</head>\n"
  
  output += "<body>\n"
  output += "<table class='table'>\n"
  output += "<style>img { width: 400px; height: 400px; }</style>\n"
  
	output += "<h1>Fotos de Marte tomadas por la sonda Curiosity</h1>\n"
	output += "<div class='container'>\n"
	output += "<div class='row justify-content-center'>\n"
	output += "<div class='row'>\n"
  
  #Guardo 2 imágenes por columna (2)
  photos.each_slice(2) do |row_photos|  
    output += "\n\t<tr>"

    #Itero sobre las fotos
    row_photos.each do |photo|  
      #Agrego cada imagen descargada en una celda
      output += "\n\t\t<td><img src='#{photo}'></td>"  
    end
    output += "\n\t</tr>"
  end
  
  output += "\n</table>\n"
  output += "</div>\n</div>\n</div>\n</body>\n</html>"

  #Escribo la tabla HTML con os datos recogidos arriba 
  File.write("fotos_nasa.html", output)  
end

#Envío la API
data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=5IVvnQKFbsRwvojektWlvGysccDxopeG1z7k0U9X") 
build_web_page(data)


#Crear un método photos_count que reciba el hash de respuesta y devuelva un nuevo hash con el nombre de la cámara y la cantidad de fotos. 

def photos_count(data)
  data["photos"].map { |x| x["camera"]["name"] }.group_by { |x| x }.map { |k, v| [k, v.count] }
end

#puts photos_count(data)  
puts "El html fuecreado con éxito"