class MailingList
    def initialize(report)
        @report = report
        self.populateList()
    end

    def validateEmail(email)
        return email.count('@')==1 && email.count('.')>=1
    end

    def getDomain(email)
        if validateEmail(email)
            return email.split('@')[1]
        else
            return "Invalid email."
        end
    end

    def countDomains
        @domainHash = Hash.new()

        @list.each do |email|
            domain = self.getDomain(email)

            if @domainHash.has_key?(domain)
                @domainHash[domain] = @domainHash[domain] + 1
            else
                @domainHash[domain] = 1
            end
        end
    end

    def genReport
        self.countDomains()
        hash = @domainHash.sort_by {|k,v| v}.reverse

        output = File.open(@report + "report.csv", "w")
        hash.each do |k,v|
            if v>0
                output.write("#{k.chomp},#{v}\n")
            end
        end
        output.close
    end

    def populateList()
        @list = []

        input = File.open(@report + ".csv", "r+")
        input.each do |line|
            @list.push(line.chomp)
        end
        input.close
    end

    def genMailing(size)
        mailFile = File.open(@report + "lists.csv", "w")

        count = 1;

        current = ''

        @list.each do |mailing|

            current << mailing+';'

            if count == 20
                mailFile.write("#{current}\n")
                current = ''
                count = 1
            else
                count = count + 1
            end
        end
        mailFile.close
    end
end

a = MailingList.new("A")
b = MailingList.new("B")

a.genReport()
a.genMailing(20)
