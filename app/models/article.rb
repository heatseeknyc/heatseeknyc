class Article < ActiveRecord::Base
	validates_uniqueness_of :article_link
end
