require 'strscan'

# Leading-indent wrap
module Leadinwrap
  def self.wrap(width, str)
    lead, str = str[/\A\s*/] || "", $'
    trail, str = str[/\s*\z/] || "", $`
    width -= lead.length
    width = 1 if width < 1
    scan = StringScanner.new(str.gsub(/\s*\n/m, " "))
    lines = []
    while scan.scan(/\A(.{1,#{width}}?)(?:\s+|$)/) || scan.scan(/\A(.+?)(?:\s|$)/)
      str = scan[1]
      if (last = lines.last) && (last.length + str.length + 1) <= width
        last << " " << str
      else
        lines << str
      end
    end
    lines << scan.rest if scan.rest?
    lines.join("\n").gsub(/^/, lead) + trail
  end
end

if $0 == __FILE__
  if ARGV.size != 1
    raise ArgumentError, "usage: #{$0} <width>"
  end
  width = ARGV[0].to_i
  $stdout.print Leadinwrap.wrap(width, $stdin.read)
end
