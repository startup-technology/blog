# == Schema Information
#
# Table name: embeds
#
#  id         :bigint(8)        not null, primary key
#  embed_type :integer          default(0), not null
#  identifier :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Embed < ApplicationRecord
  has_one :article_block, as: :blockable, dependent: :destroy
  has_one :article, through: :article_block

  enum embed_type: %i[youtube]

  validates :identifier, length: { maximum: 200 }
end
