require "pdfkit"
require_relative "writer.rb"

module Printer

  # Generete PDF from HTML and save it using company name.
  def self.create_pdf(html, path, company_name)
    pdf = generate_pdf(html)
    Writer.save_pdf(pdf, path, company_name)
  end

  private

  def self.default_options
    { page_size: "A4" }
  end

  # Generate PDF using PDFKit
  def self.generate_pdf(html)
    PDFKit.new(html, default_options)
  end

end
