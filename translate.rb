require 'optparse'
require 'ostruct'
require 'fileutils'
require 'pp'

options = OpenStruct.new
options.filename = ""
options.foldername = ""
options.str = ""
options.dst = ""
options.lang = ""
options.case = 0

OptionParser.new do |opts|
  opts.banner = "Usage: translate.rb [options]"

  opts.on("-f", "--file FILENAME", "Translate File") do |v|
	options.case = 0
    options.filename = v
  end

  opts.on("-F", "--Folder FOLDERNAME", "Translate Folder") do |v|
	options.case = 1
    options.foldername = v
  end

  opts.on("-s", "--string string", "Translate string") do |v|
	options.case = 2
    options.str = v
  end

  opts.on("-s", "--string string", "Translate string") do |v|
	options.case = 2
    options.str = v
  end

  opts.on("-l", "--language code", "Translate to what language, default is English") do |v|
    options.lang = v
  end

  opts.on("-d", "--destination Folder", "Destination folder") do |v|
    options.dst = v
  end
  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end.parse!

if ( options.case == 0 )
	# If no dst specified, save in current directory
	if( options.dst == "")
		current_dir = `pwd`.delete!("\n")
		path = current_dir+"/output/"
	else
		path = options.dst+"/output/"
	end

	puts "Translate file: " + options.filename
	unless File.directory?(path)
	  FileUtils.mkdir_p(path)
	end
	out = File.open(path+options.filename, "w")
    File.open(options.filename, "r") do |f|
      f.each_line do |line|
        str = line.delete!("\n")
		words = str.split(' ')
		words.each do |x|
			if ( x.match(/[[:alnum:]]/))
				#puts x +" --valid"
    			cmd = "trans -id \""+x+"\""
		        output = `#{cmd} 2>/dev/null` # Ignore error msg
				if ( output == "" )
					lang = "Unknown"
				else
		    		lang = output.lines[1].split(' ')[1]	
				end

				if ( lang == "\e[1mKorean\e[22m" )
					cmd2 = "trans -b -no-auto "+":"+options.lang+" "+x
		    		output2 = `#{cmd2}` 
					#puts x + " -- " + lang  + " -- " + output2 #DEBUG
					print output2.delete!("\n")
					out.write output2
				else
					#puts x + " -- " + lang #DEBUG
					print x+ ' '
					out.write x+ ' '
				end
			else 
				#print x  #DEBUG
				print x+ ' '
				out.write x+ ' '
			end
		end
		puts ""
		out.write "\n" 
      end
    end
	out.close
elsif ( options.case == 2 )
	puts "Translate string: \n" + options.str
	words = options.str.split(' ')
	print "Result: \n"

	words.each do |x|
		if ( x.match(/[[:alnum:]]/))
			puts x +" --valid"
			Timeout::timeout(5) {
    			cmd = "trans -id \""+x+"\""
			}
	        output = `#{cmd} 2>/dev/null` # Ignore error msg
			if ( output == "" )
				lang = "Unknown"
			else
		    	lang = output.lines[1].split(' ')[1]	
			end

			if ( lang == "\e[1mKorean\e[22m" )
				cmd2 = "trans -b "+":"+options.lang+" "+x
				Timeout::timeout(5) {
	    			output2 = `#{cmd2}` 
				}
				print output2
				#puts x + " -- " + lang  + " -- " + output2
			else
				#puts x + " -- " + lang
				print x+ ' '
			end
		else 
			print x+ ' '
		end
	end
	puts ""
else
	puts "Translate folder: " + options.foldername
end
