require "pdfkit"

module Writer

  # Write PDF to file with timestamp.
  def self.save_pdf(pdf, path, company_name)
    full_path = [path, "/", filename(company_name)].join
    pdf.to_file(full_path)
  end

  private

  def self.timestamp
    Time.now.strftime('%Y%m%d-%H%M%S')
  end

  def self.filename(company_name)
    [timestamp, "_", company_name, ".pdf"].join
  end

end
