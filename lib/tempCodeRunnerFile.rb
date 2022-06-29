file = File.new('dumped_file', 'r')
serial = file.read
reheated = Marshal.load(serial)
reheated.play_game
