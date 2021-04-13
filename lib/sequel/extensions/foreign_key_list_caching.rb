# frozen-string-literal: true

module Sequel
  module ForeignKeyListCaching
    def dump_foreign_key_list_cache(file)
      sch = {}
      tables.each do |table|
        sch[table] = foreign_key_list(table)
      end

      File.open(file, "wb") { |f| f.write(Marshal.dump(sch)) }
      nil
    end

    def dump_foreign_key_list_cache?(file)
      dump_foreign_key_list_cache(file) unless File.exist?(file)
    end

    def load_foreign_key_list_cache(file)
      @foreign_key_list_cache = Marshal.load(File.read(file))
      nil
    end

    def load_foreign_key_list_cache?(file)
      load_foreign_key_list_cache(file) if File.exist?(file)
    end

    def foreign_key_list(table, opts = OPTS)
      return super unless @foreign_key_list_cache

      @foreign_key_list_cache[table.to_sym]
    end
  end

  Database.register_extension(:foreign_key_list_caching, ForeignKeyListCaching)
end
