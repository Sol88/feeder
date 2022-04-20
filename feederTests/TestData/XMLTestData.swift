struct XMLTestData {
	static let emptyXMLItem =
"""
<item>
 <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
</item>
"""

	static let xmlItemWithVideoURL =
"""
<item>
 <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
 <enclosure url="https://icdn.lenta.ru/video/2022/04/20/17/20220420175209925/pic_7d3f130f70af285d506999ac84001861.mpeg" type="video/mpeg" length="83120"/>
</item>
"""

	static let xmlItemWithoutCDATADescription =
"""
<item>
 <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
 <description>
  Test text
 </description>
</item>
"""

	static let xmlItem =
"""
<item>
 <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
 <author>Марина Погосян</author>
 <title>Юэн Макгрегор женится на Мэри Элизабет Уинстэд</title>
 <link>https://lenta.ru/news/2022/04/20/zhenites/</link>
 <description>
  <![CDATA[Шотландский актер Юэн Макгрегор женится на коллеге по сериалу «Фарго», американской актрисе Мэри Элизабет Уинстэд. Свадьба запланирована на 22 апреля. Летом 2021 года у пары родился родился ребенок. Артистка стала матерью впервые, в то время как у актера есть две родные и две приемные дочери.]]>

 </description>
 <pubDate>Wed, 20 Apr 2022 18:09:53 +0300</pubDate>
 <enclosure url="https://icdn.lenta.ru/images/2022/04/20/17/20220420175209925/pic_7d3f130f70af285d506999ac84001861.jpg" type="image/jpeg" length="83120"/>
 <category>Культура</category>
</item>
"""

	static let xmlItems =
"""
<channel>
 <item>
  <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
  <author>Марина Погосян</author>
  <title>Юэн Макгрегор женится на Мэри Элизабет Уинстэд</title>
  <link>https://lenta.ru/news/2022/04/20/zhenites/</link>
  <description>
   <![CDATA[Шотландский актер Юэн Макгрегор женится на коллеге по сериалу «Фарго», американской актрисе Мэри Элизабет Уинстэд. Свадьба запланирована на 22 апреля. Летом 2021 года у пары родился родился ребенок. Артистка стала матерью впервые, в то время как у актера есть две родные и две приемные дочери.]]>

  </description>
  <pubDate>Wed, 20 Apr 2022 18:09:53 +0300</pubDate>
  <enclosure url="https://icdn.lenta.ru/images/2022/04/20/17/20220420175209925/pic_7d3f130f70af285d506999ac84001861.jpg" type="image/jpeg" length="83120"/>
  <category>Культура</category>
 </item>
 <item>
  <guid>https://lenta.ru/news/2022/04/20/zhenites/</guid>
  <author>Марина Погосян</author>
  <title>Юэн Макгрегор женится на Мэри Элизабет Уинстэд</title>
  <link>https://lenta.ru/news/2022/04/20/zhenites/</link>
  <description>
   <![CDATA[Шотландский актер Юэн Макгрегор женится на коллеге по сериалу «Фарго», американской актрисе Мэри Элизабет Уинстэд. Свадьба запланирована на 22 апреля. Летом 2021 года у пары родился родился ребенок. Артистка стала матерью впервые, в то время как у актера есть две родные и две приемные дочери.]]>

  </description>
  <pubDate>Wed, 20 Apr 2022 18:09:53 +0300</pubDate>
  <enclosure url="https://icdn.lenta.ru/images/2022/04/20/17/20220420175209925/pic_7d3f130f70af285d506999ac84001861.jpg" type="image/jpeg" length="83120"/>
  <category>Культура</category>
 </item>
</channel>
"""
}
