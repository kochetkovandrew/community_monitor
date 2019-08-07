task compare_words: :environment do
  communities = Community.where(screen_name: ['spida_net', 'vichnet']).all
  user_vk_ids = communities.collect do |community|
    community.posts.collect do |post|
      post.post_comments.collect {|comment| comment.user_vk_id}
    end
  end
  user_vk_ids.flatten!.sort!.uniq!
  user_words = {}
  user_vk_ids.each do |user_vk_id|
    user = Member.find_by_vk_id user_vk_id
    if user
      words = user.post_comments.all.collect{|comment| comment.raw['text'].gsub(/\[.+\]/, '').scan(/[А-Яа-я]+/)}.flatten.collect{|word| word.downcase}.group_by(&:itself).transform_values(&:count).map{|key, value| [key, value]}.sort{|a, b| a[1] <=> b[1]}
      count = words.inject(0){|sum, word| sum + word[1] }
      user_words[user_vk_id] = Hash[words.collect{|word| [word[0], word[1]*1.0/count]}]
    end
  end
  decls = {}
  user_words.each do |id, words|
    decl = 0.0
    if id != 246924206
      # compare words
      user_words[246924206].each do |word, freq|
        freq2 = words[word] || 0.0
        decl += (freq - freq2)**2
      end
    end
    decls[id] = decl
  end
  p decls.collect{|a,b| [a,b]}.sort{|a,b| b[1]<=>a[1]}
end