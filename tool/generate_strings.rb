#!/usr/bin/env ruby
require 'json'

LANGUAGES = {
  :en => "English",
  :fi => "Finnish",
  :sv => "Swedish",
  :uk => "Ukrainian",
  :ru => "Russian",
  :sk => "Slovak",
  :cs => "Czech",
  :pl => "Polish",
  :ro => "Romanian",
  :de => "German",
  :fr => "French",
  :es => "Spanish",
  :pt => "Portuguese",
  :zh => "Chinese",
  :ja => "Japanese",
}

column_languages = []
STDIN.readline.chomp.split("\t")[2..-1].each.with_index do |language_label, column_index|
  column_languages << LANGUAGES.rassoc(language_label).shift
end

localized_strings = {}
STDIN.each_line do |line|
  column_data = line.chomp.split("\t")
  string_id, _, string_translations = column_data.shift, column_data.shift, column_data
  localized_strings[string_id] ||= {}
  string_translations.each.with_index do |string_translation, column_index|
    string_language = column_languages[column_index]
    localized_strings[string_id][string_language] = string_translation
  end
end

puts "  // BEGIN GETTERS"
localized_strings.keys.sort.each do |string_id|
  puts "  String get #{string_id} => get('#{string_id}');"
end
puts "  // END GETTERS"
puts
puts "  static Map<String, Map<String, String>> _data ="
puts "  { // BEGIN STRINGS"
localized_strings.keys.sort.each do |string_id|
  string_original = localized_strings[string_id][:en]
  puts "    '#{string_id}': {"
  localized_strings[string_id].keys.sort.each do |language_code|
    string_translation = localized_strings[string_id][language_code]
    next if language_code != :en && string_translation == string_original # skip redundant strings
    next if string_translation.empty?
    puts "      '#{language_code}': #{string_translation.to_json},"
  end
  puts "    },"
end
puts "  }; // END STRINGS"
