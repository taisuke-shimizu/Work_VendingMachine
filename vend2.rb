class Drink
  attr_reader :name, :price, :count
  def initialize(name, price, count)
    @name = name
    @price = price
    @count = count
  end
  def self.redbull
    self.new('redbull', 200, 5)
  end
  def self.water
    self.new('water', 100, 5)
  end
end

class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze
  
  def initialize
    @sales = 0
    @slot_money = 0
    @drink = [{name: 'coke', price: 120, count: 5}]
  end
  
  def slot_money(money)
    if MONEY.include?(money)
      @slot_money += money
      puts "#{money}円投入されました"
    else
      MONEY.each { |money| print "#{money}円" }
      puts 'のいずれかを投入してください！'
      puts "#{money}円お返しします"
    end
  end
  
  def sum_money
    puts "現在の投入金額は#{@slot_money}円です"
  end
  
  def return_money
    puts "#{@slot_money}円のお返しです"
    @slot_money = 0
  end
  
  def check_stock
    puts '現在の商品はこちらです'
    @drink.each do |drink|
      puts "#{drink[:name]}(#{drink[:price]}円)：#{drink[:count]}本"
    end
  end

  def add_drink(drink)
    @drink << { name: drink.name, price: drink.price, count: drink.count }
    puts "#{@drink.last[:name]}(#{@drink.last[:price]}円)を#{@drink.last[:count]}本追加！"
  end
  # 外から追加したい場合は以下の方法で行う.
  # def add_drink(new_drink)
  #   @drink << new_drink
  #   puts "#{@drink.last[:name]}(#{@drink.last[:price]}円)を#{@drink.last[:stock]}本追加！"
  # end

  def add_drink_stock
    puts '在庫を追加したい商品番号を入力してください'
    @drink.each_with_index do |drink, i|
      puts "#{i+1} → #{drink[:name]}：#{drink[:price]}円"
    end
    n = gets.to_i - 1
    puts '何本追加しますか？'
    add = gets.to_i
    @drink[add][:count] += 1
    puts "#{@drink[add][:name]}の在庫数が#{@drink[add][:count]}になりました"
  end

  def purchase
    while true do
    puts "購入したい飲み物の番号を選択してください\n買い物を終了したい場合は0を押してください"
    @drink.each_with_index do |drink, i| 
      puts "#{i+1} → #{drink[:name]}：#{drink[:price]}円" 
    end
    n = gets.to_i - 1
      if n == -1
        puts 'ありがとうございました〜'
        win_or_lose
        return_money
        break
      else
        if @slot_money < @drink[n][:price]
          puts '料金不足です'
          break
        elsif @drink[n][:count] < 1
          puts '残念！在庫切れです...'
          break
        elsif @slot_money >= @drink[n][:price]
          puts "#{@drink[n][:name]}をゲット！やったね！！！！！！！"
          @drink[n][:count] -= 1
          @slot_money -= @drink[n][:price]
          @sales += @drink[n][:price]
        end
      end
    end
  end

  def how_much_sales
    puts "現在の売り上げは#{@sales}円です"
  end

  # 当たり機能
  def win_or_lose
    num1, num2 = [rand(0...5),rand(0...5)]
    puts "当たるかな？"
    3.times do
      puts'.'
      sleep(0.3)
    end
    if num1 == num2
      puts "大当たり！\n好きな飲みもの１本無料サービス！どれにしますか？"
      @drink.each_with_index do |drink,i| 
        puts "#{i+1} → #{drink[:name]}" 
      end
      n = gets.to_i - 1
      if @drink[n][:count] < 1
        puts '残念！在庫切れです...'
      elsif 
        puts "#{@drink[n][:name]}をゲット！やったね！！！！！！！"
        @drink[n][:count] -= 1
      end
    else
      puts "残念ハズレです..."
    end
  end

  # 管理者かお客さんかでシステムを分ける
end

# require './vend2.rb'
vm = VendingMachine.new

# puts Drink.redbull
# puts Drink.redbull.name
# puts Drink.redbull.price
# puts Drink.redbull.count

# vm = VendingMachine.new

# vm.slot_money(500)

# vm.check_stock

# ステップ０ お金の投入と払い戻し
# 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
# 投入は複数回できる。
# vm.slot_money(11)
vm.slot_money(500)
# vm.slot_money(500)
# 投入金額の総計を取得できる。
# vm.sum_money
vm.add_drink(Drink.redbull)
# vm.add_drink(Drink.water)
vm.purchase
# 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
# vm.return_money

# ステップ１ 扱えないお金
# ステップ0で実装済

# ステップ２ ジュースの管理
# 値段と名前の属性からなるジュースを１種類格納できる。初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。
# 格納されているジュースの情報（値段と名前と在庫）を取得できる。
# vm.check_stock

# ステップ３ 購入
# 投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。
# ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。
# 投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。
# vm.purchase
# 現在の売上金額を取得できる。
# vm.how_much_sales
# 払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。

# ステップ４ 機能拡張
# ジュースを3種類管理できるようにする。
# 在庫にレッドブル（値段:200円、名前”レッドブル”）5本を追加する。
# vm.add_drink(Drink.redbull)
# # 在庫に水（値段:100円、名前”水”）5本を追加する。
# vm.add_drink(Drink.water)
# # 投入金額、在庫の点で購入可能なドリンクのリストを取得できる。
# vm.check_stock

# vm.purchase
# vm.how_much_sales

# ステップ５ 釣り銭と売り上げ管理
# ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、釣り銭（投入金額とジュース値段の差分）を出力する。
# ジュースと投入金額が同じ場合、つまり、釣り銭0円の場合も、釣り銭0円と出力する。
# 釣り銭の硬貨の種類は考慮しなくてよい。