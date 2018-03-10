# == Schema Information
#
# Table name: articles
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  author_id    :integer
#  uuid         :string(255)
#  slug         :string(255)
#  eye_cache    :string(255)
#  title        :string(255)
#  description  :text(65535)
#  body         :text(65535)
#  state        :integer          default("draft"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_deleted_at    (deleted_at)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#  index_articles_on_uuid          (uuid)
#

class Article < ApplicationRecord
  mount_uploader :eye_cache, ImageUploader

  belongs_to :category
  belongs_to :author

  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_blocks, -> { order(:level) }, inverse_of: :article
  has_many :sentences, through: :article_blocks, source: :blockable, source_type: 'Sentence'
  has_many :media, through: :article_blocks, source: :blockable, source_type: 'Medium'
  has_many :embeds, through: :article_blocks, source: :blockable, source_type: 'Embed'

  enum state: %i[draft published]

  validates :slug, slug_format: true, uniqueness: true, length: { maximum: 255 }, allow_blank: true
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :state, presence: true
  validates :eye_cache,
            file_size: { less_than_or_equal_to: 10.megabytes },
            file_content_type: { allow: %w[image/jpeg image/png] }

  with_options if: :published? do |v|
    v.validates :slug, slug_format: true, presence: true, length: { maximum: 255 }
    v.validates :published_at, presence: true
    v.validates :category_id, presence: true
  end

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :slug, to: :category, prefix: true, allow_nil: true
  delegate :name, to: :author, prefix: true, allow_nil: true

  before_create -> { self.uuid = SecureRandom.uuid }

  scope :viewable, -> { published.where('published_at < ?', Time.current) }
  scope :new_arrivals, -> { viewable.order(published_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_contain, ->(word) { where('title LIKE ?', "%#{word}%") }

  class << self
    def search(search_articles_form)
      relation = Article.distinct

      if search_articles_form.category_id?
        relation = relation.by_category(search_articles_form.category_id)
      end

      search_articles_form.title_words.each do |word|
        relation = relation.title_contain(word)
      end

      relation
    end
  end

  # FIXME: レンダリングのために引数でコントローラーを渡しているが、そもそもコントローラーに移した方がいいかもしれない
  def build_body(controller)
    result = ''

    article_blocks.each do |article_block|
      result << if article_block.sentence?
                  sentence = article_block.blockable
                  sentence.body
                elsif article_block.medium?
                  medium = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                  controller.render_to_string("shared/_media_#{medium.media_type}", locals: { medium: medium }, layout: false)
                elsif article_block.embed?
                  embed = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                  controller.render_to_string("shared/_embed_#{embed.embed_type}", locals: { embed: embed }, layout: false)
                end
    end

    result
  end

  def next_article
    @next_article ||= Article.viewable.order(published_at: :asc).where('published_at > ?', published_at).first
  end

  def prev_article
    @prev_article ||= Article.viewable.order(published_at: :desc).where('published_at < ?', published_at).first
  end
end
