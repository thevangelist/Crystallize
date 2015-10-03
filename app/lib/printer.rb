require "pdfkit"

module Printer

  # Generete and write pdf with company name.
  def self.create_pdf(html, company_name)
    write_file(generate_pdf(html), company_name)
  end

  private

  # Generate PDF using PDFKit
  def self.generate_pdf(html)
    PDFKit.new(html, :page_size => "A4")
  end

  # Write PDF to file with timestamp.
  def self.write_file(pdf, company_name)
    timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
    pdf.to_file("files/#{timestamp}-#{company_name}.pdf")
  end

end
