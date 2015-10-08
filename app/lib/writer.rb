require "pdfkit"

module Writer

  # Write PDF to file with timestamp.
  def self.save_pdf(pdf, path)
    full_path = [path, "/", filename].join
    pdf.to_file(full_path)
  end

  private

  def self.timestamp
    Time.now.strftime('%Y%m%d-%H%M%S')
  end

  def self.filename
    [timestamp, ".pdf"].join
  end

end
