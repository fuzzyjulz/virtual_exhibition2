class AddPublicChatAndTwitterRollAndTwitterHashTagAndSurveyUrlAndPrizeGiveawayDescriptionAndNewsletterDescriptionToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :public_chat, :boolean
    add_column :booths, :twitter_roll, :boolean
    add_column :booths, :twitter_hash_tag, :string
    add_column :booths, :survey_url, :string
    add_column :booths, :prize_giveaway_description, :text
    add_column :booths, :newsletter_description, :text
  end
end
