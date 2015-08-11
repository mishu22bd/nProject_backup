class FileUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "boxelements/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

end