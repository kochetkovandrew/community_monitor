class Array
  def each_show_progress
    full_p = 100
    prev_p = 0
    for j in 1..full_p
      print '='
    end
    elem_count = self.count
    if elem_count > 0
      handled_count = 0
      puts ''
      self.each do |elem|
        curr_p = (handled_count * full_p) / elem_count
        for j in 1..(curr_p - prev_p)
          print '+'
        end
        prev_p = curr_p
        handled_count += 1
        yield elem
      end
      curr_p = (handled_count * full_p) / elem_count
      for j in 1..(curr_p - prev_p)
        print '+'
      end
      puts ''
    end
  end
end
