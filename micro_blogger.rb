require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end
  
  def tweet(message)
    if message.length > 140
      puts "Message cannot be longer than 140 characters long"
    else
      @client.update(message)
    end
  end
  
  def dm(target, message)
    if self.follower?(target)
      puts "Sent #{message} to #{target}"
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "Cannot DM #{target} because #{target} is not following you."
    end
  end
  
  def follower?(person)
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    if screen_names.include?(person)
      true
    else
      false
    end
  end
  
  def run
    command = ""
    while command != "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        else
           puts "Sorry, I don't know how to #{command}"
      end
    end
  end
  
end

blogger = MicroBlogger.new

blogger.run
