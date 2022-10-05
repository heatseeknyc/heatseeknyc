class Article < ApplicationRecord
	validates_uniqueness_of :article_link
end
