# -*- encoding: UTF-8 -*-
# migemojs 直下で実行すると scripts/migemo.js と dicts/* を元に
# scripts/migemo_with_dict.js を出力する
text = File.read("scripts/migemo.js", encoding: "utf-8")
clist_exp = text.match(/cList : (\[.*?\])/).captures.first
clist = eval clist_exp
list = ""
clist.each do |c|
  list << "    '#{c}': [\n"
  lines = File.readlines("dicts/#{c}a2.txt", encoding: "utf-8")
  list << lines.map {|line| "      '" + line.chomp.gsub(/['\\]/, '\\\1') + "\\n'"}.join(",\n")
  list << "].join(''),\n"
end

File.open("scripts/migemo_with_dict.js", "w", encoding: "utf-8") do |f|
  f.write text.sub(/  this.dictionary.loadAll \(\);\n/, <<EOS)
  // ローカルでは XMLHttpRequest は使用できず loadAll でエラーが発生するため、
  // loadAll を使用しない初期化処理に書き換える
  this.dictionary.list = {
#{list.chomp}
  };
EOS
end
