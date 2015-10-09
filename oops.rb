#!/usr/bin/env ruby

require 'json'

class Oops

  EXTENSIONS = ['.rb', '.coffee', '.haml', '.erb', '.js']
  CHECKS = [
    /\bputs\b/,     # obvious
    /\bp\b/,        # p shorthand
    
    /\bpretty_print\b/,
    /\bpp\b/,

    /\bawesome_print\b/,
    /\bap\b/,

    /console\.log/,

    # missed rebase / merge code
    /^<{6,}/, 
    /^>{6,}/,
    /^={6,}/
  ]

  attr_accessor :code, :extensions, :config_json, 
                :include_paths, :exclude_paths

  def initialize(options = {})
    @code           = options[:code] || '/code'
    @extensions     = EXTENSIONS
    @config_json    = import_config_json
  end

  def include_paths
    @include_paths ||= config_json['include_paths'] || [File.join('**', '*')]
  end

  def import_config_json
    File.exist?('/config.json') ? JSON.parse(File.read('/config.json')) : {}
  end

  def should_check_file?(file)
    extensions.include? File.extname(file)
  end

  def run!
    files_to_check.each do |file|
      next unless should_check_file? file
      check_file! file
    end
  end

  def files_to_check
    @files_to_check ||= include_paths.map do |glob|
      Dir.glob(glob)
    end.flatten.compact
  end

  def check_file!(file)
    lines = File.readlines(file)
    lines.each_with_index do |contents, line_number|
      check_line!(contents, line_number, file)
    end
  end

  def check_line!(contents, line_number, file_name)
    CHECKS.each do |check|
      matches = check.match(contents)
      next unless matches
      0.upto(matches.size - 1) do |i|
        log_line!(matches[i], 
          matches.begin(i), matches.end(i), line_number, file_name
        )
      end
    end
  end

  def log_line!(matched_str, first_col, last_col, line_number, file_name)
    STDOUT.puts JSON.dump(
      type: "issue",
      check_name: "Oopsie found",
      description: "#{matched_str} found",
      categories: ["Bug Risk"],
      remediation_points: 500,
      location: {
        path: file_name,
        positions: {
          begin: {
            line: line_number + 1,
            column: first_col + 1
          },
          end: {
            line: line_number + 1,
            column: last_col + 1 
          }
        }
      }
    ) + "\0"
  end
end