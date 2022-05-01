class Scrapper

    attr_accessor :array
    
    def initialize
        @array =[]
        townhall_url = "http://annuaire-des-mairies.com/val-d-oise.html"
        Nokogiri::HTML(URI.open(townhall_url)).xpath("//a[@class='lientxt']/@href").each do |link|
            result = Hash.new
            result[link.text[5..-6].capitalize] = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com#{link.text[1..-1]}")).xpath('//main/section[2]//table/tbody/tr[4]/td[2]').text
            @array << result 
        end
    end

    def save_as_JSON
        File.open("./db/emails.json","w") do |f|
             f.write(@array.to_json)
        end
    end

    def save_as_spreadsheet
        session = GoogleDrive::Session.from_config("config.json")
        ws = session.spreadsheet_by_key("13qbaKn5z31V5vgrwwREyNppnfnf-nD3GbTHoNzy6lIs").worksheets[0]
        ws[1, 1] = "Ville"
        ws[1,2] = "Email mairie"
        @array.each do |hash|
            ws.insert_rows(ws.num_rows + 1, [[hash.keys.first, hash.values.first]])
        end
        ws.save
    end

    def save_as_csv
        headers = ["Ville", "Email mairie"]
        @array.each do |hash|
            ville = hash.keys.first
            email = hash.values.first
            CSV.open("db/emails.csv", "a+") do |csv|
                csv << headers if csv.count.eql? 0
                csv << [ville, email]
            end
        end
    end
end
