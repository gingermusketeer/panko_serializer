# frozen_string_literal: true
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "json"
require "terminal-table"
require "rake/extensiontask"
require "pty"

gem = Gem::Specification.load( File.dirname(__FILE__) + "/panko_serializer.gemspec" )


Rake::ExtensionTask.new("panko_serializer", gem) do |ext|
  ext.lib_dir = "lib/panko"
end

Gem::PackageTask.new(gem) do |pkg|
  pkg.need_zip = pkg.need_tar = false
end

RSpec::Core::RakeTask.new(:spec)
Rake::Task[:spec].prerequisites << :compile

task default: :spec

def print_and_flush(str)
  print str
  $stdout.flush
end

def run_process(cmd)
  puts "> Running #{cmd}"
  lines = []
  PTY.spawn(cmd) do |stdout, stdin, pid|
    begin
      stdout.each do |line|
        print_and_flush '.'
        lines << line
      end
    rescue Errno::EIO
      puts "Errno:EIO error, but this probably just means " +
            "that the process has finished giving output - #{cmd}"
    end
  end

  lines
rescue PTY::ChildExited
  puts "The child process exited! - #{cmd}"
  []
end

def run_benchmarks(files, items_count: 7_000)
  headings = ["Benchmark", "ip/s", "allocs/retained"]
  files.each do |benchmark_file|

    lines = run_process "ITEMS_COUNT=#{items_count} RAILS_ENV=production ruby #{benchmark_file}"
    rows = lines.map do |line|
      begin
        row = JSON.parse(line)
      rescue JSON::ParserError
        puts "> Failed parsing json"
        puts lines.join
        exit
      end
      row.values
    end

    puts "\n\n"
    title = File.basename(benchmark_file, ".rb")
    table = Terminal::Table.new title: title, headings: headings, rows: rows
    puts table
  end
end

desc "Run all benchmarks"
task :benchmarks do
  run_benchmarks Dir[File.join(__dir__, "benchmarks", "**", "bm_*")]
end

desc "Type Casts - Benchmarks"
task :bm_type_casts do
  run_benchmarks Dir[File.join(__dir__, "benchmarks", "type_casts", "bm_*")], items_count: 0
end

desc "Sanity Benchmarks"
task :sanity do
  puts Time.now.strftime("%d/%m %H:%M:%S")
  puts "=========================="

  run_benchmarks [
    File.join(__dir__, "benchmarks", "sanity.rb")
  ], items_count: 2300

  puts "\n\n"
end
