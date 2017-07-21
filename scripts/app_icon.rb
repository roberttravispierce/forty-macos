require 'fileutils'

class AppIconVariant
  def initialize(filename, out_folder, points, density)
    @filename = filename
    @out_folder = out_folder
    @points = points
    @density = density
  end

  def as_command
    "convert #{@filename} -resize #{dimensions} #{@out_folder}/#{new_filename}"
  end

  private

  def size
    @points * @density
  end

  def dimensions
    [size, 'x', size].join
  end

  def new_filename
    basename, extension = @filename.split '.'
    "#{basename}-#{@points}@#{@density}x.#{extension}"
  end
end

filename = ARGV.first

out_folder = Time.now.strftime('%Y%m%d%H%M%S')

FileUtils.mkdir_p out_folder

variants = [
  AppIconVariant.new(filename, out_folder, 16, 1),
  AppIconVariant.new(filename, out_folder, 16, 2),
  AppIconVariant.new(filename, out_folder, 32, 1),
  AppIconVariant.new(filename, out_folder, 32, 2),
  AppIconVariant.new(filename, out_folder, 128, 1),
  AppIconVariant.new(filename, out_folder, 128, 2),
  AppIconVariant.new(filename, out_folder, 256, 1),
  AppIconVariant.new(filename, out_folder, 256, 2),
  AppIconVariant.new(filename, out_folder, 512, 1),
  AppIconVariant.new(filename, out_folder, 512, 2),
]

for variant in variants do
  system variant.as_command
end
