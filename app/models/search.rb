class Search
  include ActiveModel::Validations

  INDICES = %w[answer question user comment].freeze

  attr_accessor :query, :indices

  validates :query, presence: true
  validate :validate_indices

  def initialize(attr = {})
    @query = attr[:query]
    @indices = attr[:indices] || []
  end

  def self.find(params)
    search = new(params)
    search.validate
    search
  end

  def results
    return [] if invalid?

    escaped_query = ThinkingSphinx::Query.escape(query)
    ThinkingSphinx.search(escaped_query, indices: indices)
  end

  private

  def validate_indices
    errors.add(:indices) unless (indices - INDICES).empty?
  end
end
