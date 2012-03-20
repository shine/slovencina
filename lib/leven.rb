$KCODE = 'UTF-8'

def ld(s,t)
  
  
  n = s.size
  m = t.size
  a = Array.new

  r = Array.new
  rz = Array.new

  0.upto(m) {|x| r.push(0)}

  0.upto(n) {|x|a.push(r.dup)}
  a.each_index {|x| a[x][0] = x}
  0.upto(m) {|x| a[0][x] = x}

  cost =  0
  1.upto(n) do |i|
    1.upto(m) do |j|
      cost = s[i] == t[j] ? 0 : 1
      a[i][j] = [a[ i- 1][j] +1,a[i][j - 1] + 1,a[i - 1][j -1] + cost].min
    end
  end
  a[n][m]
end
